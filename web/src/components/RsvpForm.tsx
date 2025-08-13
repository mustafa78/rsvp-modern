import { useForm } from 'react-hook-form'
import { z } from 'zod'
import { zodResolver } from '@hookform/resolvers/zod'
import { api } from '../api/client'
import { useParams } from 'react-router-dom'

const Schema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  phone: z.string().optional(),
  status: z.enum(['YES','NO','MAYBE']),
  role: z.enum(['COOK','FILL','OTHER']).optional(),
  headcount: z.coerce.number().int().min(1)
})

type FormValues = z.infer<typeof Schema>

export default function RsvpForm(){
  const { id } = useParams()
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<FormValues>({ resolver: zodResolver(Schema) })

  return (
    <form className="space-y-3" onSubmit={handleSubmit(async (values)=>{
      await api.post(`/events/${id}/rsvps`, values)
      alert('Thanks! Your RSVP is saved.')
    })}>
      <input className="input" placeholder="Name" {...register('name')} />
      <input className="input" placeholder="Email" {...register('email')} />
      <input className="input" placeholder="Phone" {...register('phone')} />
      <select className="input" {...register('status')}>
        <option value="YES">Yes</option>
        <option value="NO">No</option>
        <option value="MAYBE">Maybe</option>
      </select>
      <select className="input" {...register('role')}>
        <option value="COOK">Cook</option>
        <option value="FILL">Fill</option>
        <option value="OTHER">Other</option>
      </select>
      <input className="input" type="number" placeholder="Headcount" {...register('headcount')} />
      <button disabled={isSubmitting} className="btn">{isSubmitting ? 'Saving…' : 'Submit'}</button>
      {Object.keys(errors).length>0 && <pre className="text-red-600">{JSON.stringify(errors,null,2)}</pre>}
    </form>
  )
}
