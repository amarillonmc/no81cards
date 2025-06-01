--方程式运动员智能改造装置
local s,id,o=GetID()
function s.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.lvdfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(2) and c:IsSetCard(0x107)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.lvdfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,s.lvdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g then
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(c:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	local tc=e:GetLabelObject()
	local lv=tc:GetLevel()-1
	Duel.HintSelection(Group.FromCards(tc))
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(lv)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0x107) and c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or (not c:IsForbidden() and c:CheckUniqueOnField(tp)))
end
function s.desfilter(c)
	return c:IsSetCard(0x107) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsForbidden() or not tc:CheckUniqueOnField(tp) or Duel.SelectOption(tp,1190,aux.Stringid(id,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit2(e,c)
	return not c:IsAttack(0) and c:IsLocation(LOCATION_EXTRA)
end
