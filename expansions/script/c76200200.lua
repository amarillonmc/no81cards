--太祖之龙 提丰
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),12,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(2)
	e1:SetCondition(s.atcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.check(c)
	return c and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if s.check(Duel.GetAttacker()) or s.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)>0 and Duel.GetFlagEffect(tp,id+o*100)==0 end
	Duel.RegisterFlagEffect(tp,id+o*100,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local dam=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if dam~=0 then
		Duel.Damage(1-tp,dam*600,REASON_EFFECT)
		local op=Duel.GetOperatedGroup()
		if op:IsContains(c) then
			local owner_player=c:GetOwner()
			local reset_flag=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
			if owner_player==tp then
				reset_flag=reset_flag+RESET_SELF_TURN
			else
				reset_flag=reset_flag+RESET_OPPO_TURN
			end
			if Duel.GetTurnPlayer()==owner_player and Duel.GetCurrentPhase()==PHASE_END then
				e:GetLabelObject():SetLabel(Duel.GetTurnCount())
				c:RegisterFlagEffect(id+o*200,reset_flag,0,2)
			else
				e:GetLabelObject():SetLabel(0)
				c:RegisterFlagEffect(id+o*200,reset_flag,0,1)
			end
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel() and e:GetHandler():GetFlagEffect(id+o*200)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end