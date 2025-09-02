--大风起兮
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.accon)
	e2:SetTarget(s.actarget)
	e2:SetCost(s.accost)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	--act limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(1,1)
	e0:SetValue(s.aclimit)
	c:RegisterEffect(e0)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.sumlimit)
	c:RegisterEffect(e3)
end


function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	local tp=tc:GetControler()
	local seq=tc:GetSequence()
	return tc and tp and seq and ((seq==5 and not Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and not Duel.CheckLocation(tp,LOCATION_MZONE,3)))
end

function s.accon(e)
	s[0]=false
	return true
end
function s.actarget(e,te)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsLocation(LOCATION_ONFIELD) and not (tc:IsLocation(LOCATION_FZONE) or tc:IsLocation(LOCATION_PZONE))
end
function s.accost(e,te)
	local tc=te:GetHandler()
	local tp=tc:GetControler()
	local seq=tc:GetSequence()
	return (tc:IsLocation(LOCATION_MZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) or (seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3)))) or (tc:IsLocation(LOCATION_SZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1))))
end
function s.acop(e,eg,ep,ev,re,r,rp)
	if s[0] then return end
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=tc:GetControler()
	local seq=tc:GetSequence()
	local pos=tc:GetPosition()
	local a=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if tc:IsLocation(LOCATION_MZONE) and (seq==0 or seq==5) then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfffd) end
	if tc:IsLocation(LOCATION_MZONE) and seq==1 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfffa) end
	if tc:IsLocation(LOCATION_MZONE) and seq==2 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfff5) end
	if tc:IsLocation(LOCATION_MZONE) and seq==3 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xffeb) end
	if tc:IsLocation(LOCATION_MZONE) and (seq==4 or seq==6) then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfff7) end
	if tc:IsLocation(LOCATION_SZONE) and seq==0 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfdff) end
	if tc:IsLocation(LOCATION_SZONE) and seq==1 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xfaff) end
	if tc:IsLocation(LOCATION_SZONE) and seq==2 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xf5ff) end
	if tc:IsLocation(LOCATION_SZONE) and seq==3 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xebff) end
	if tc:IsLocation(LOCATION_SZONE) and seq==4 then a=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,0xf7ff) end
	local nseq=0
	if not a then return end
	if a==0x1 or a==0x100 then nseq=0
	elseif a==0x2 or a==0x200 then nseq=1
	elseif a==0x4 or a==0x400 then nseq=2
	elseif a==0x8 or a==0x800 then nseq=3
	elseif a==0x10 or a==0x1000 then nseq=4
	else end
	Duel.MoveSequence(tc,nseq)
	s[0]=true
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end