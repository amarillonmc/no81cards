local m=53757011
local cm=_G["c"..m]
cm.name="次元宙界龙 雷德史福特 "
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,5,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.matcon)
	e1:SetOperation(cm.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.matcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,7))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.seqcon)
	e3:SetTarget(cm.seqtg)
	e3:SetOperation(cm.seqop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(4179255)
	c:RegisterEffect(e4)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(3) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cm.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION~=SUMMON_TYPE_FUSION or se:GetHandler():IsCode(m+1)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m+33,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function cm.matcheck(e,c)
	local g=c:GetMaterial()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(#g*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		local desc=(code-53757000)/2
		if desc<1 or desc>5 then desc=0 end
		c:RegisterFlagEffect(0,RESET_EVENT+0xff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,desc))
		c:CopyEffect(code,RESET_EVENT+0xff0000,1)
	end
	if #g==5 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetOwnerPlayer(tp)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
	end
	e:GetLabelObject():SetLabel(#g-1)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffectLabel(m+33) and e:GetHandler():GetFlagEffectLabel(m+33)>0
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then return ((seq>0 and SNNM.DisMZone(tp)&(1<<(seq-1))) or (seq<4 and SNNM.DisMZone(tp)&(1<<(seq+1))==0)) and c:GetFlagEffect(m)<c:GetFlagEffectLabel(m+33) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.desfilter(c,nseq,tp)
	local seq=aux.MZoneSequence(c:GetSequence())
	if c:GetControler()~=tp then seq=math.abs(seq-4) end
	return nseq==seq
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or seq>4 then return end
	local flag=0
	if seq>0 and SNNM.DisMZone(tp)&(1<<(seq-1))==0 then flag=flag|(1<<(seq-1)) end
	if seq<4 and SNNM.DisMZone(tp)&(1<<(seq+1))==0 then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.Hint(HINT_ZONE,tp,s)
	local sg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,nseq,tp)
	if #sg>0 then Duel.Destroy(sg,REASON_RULE,LOCATION_REMOVED) end
	Duel.MoveSequence(c,nseq)
end
