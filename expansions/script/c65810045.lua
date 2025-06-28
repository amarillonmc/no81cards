--夏日共鸣曲·阳光音阶
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--放置
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.recon)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	--通召
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.Target1)
	e4:SetOperation(s.activate1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.spcon1)
	e5:SetTarget(s.Target1)
	e5:SetOperation(s.activate1)
	c:RegisterEffect(e5)
end

function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(id+1)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,id+1)==0
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	   local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.Destroy(fc,REASON_RULE)
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	end   
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp) and e:GetHandler():GetFlagEffect(id)<=0
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)<=0
end
function s.sumfilter(c)
	return c:IsSetCard(0x3a31) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function s.Target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
