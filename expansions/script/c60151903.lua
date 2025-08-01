--线膛燧发枪 黎明之翼
function c60151903.initial_effect(c)
	--pendulum summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c60151903.e1con)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c60151903.e2splimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,60151902))
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_PZONE)
	e4:SetOperation(c60151903.e4op)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151903,0))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetTarget(c60151903.e5tg)
	e5:SetOperation(c60151903.e5op)
	c:RegisterEffect(e5)
end
function c60151903.e1confilter(c)
	return c:IsCode(60151902)
end
function c60151903.e1con(e)
	return not Duel.IsExistingMatchingCard(c60151903.e1confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
		or e:GetHandler():GetLeftScale()==0
end
function c60151903.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c60151903.e2splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c60151903.e4opcheck(c,tp)
	return c and c:IsControler(tp) and c:IsCode(60151902)
end
function c60151903.e4op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if (c60151903.e4opcheck(Duel.GetAttacker(),tp) or c60151903.e4opcheck(Duel.GetAttackTarget(),tp)) then  
		local c=e:GetHandler()
		if c:GetLeftScale()==0 then return end
		local scl=1
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-scl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function c60151903.e5tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c60151903.e5tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151903.e5tgfilter,tp,0,LOCATION_ONFIELD,1,nil) 
		and e:GetHandler():GetFlagEffect(60151901)~=0 end
	local g=Duel.GetMatchingGroup(c60151903.e5tgfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5043010,2))
end
function c60151903.e5op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Recover(tp,1000,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c60151903.e5tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end