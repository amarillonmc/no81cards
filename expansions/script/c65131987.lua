--绝不放弃，永远
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Remove drawn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ddcon)
	e1:SetCost(s.ddcost)
	e1:SetTarget(s.ddtg)
	e1:SetOperation(s.ddop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.fakercon1)
	e2:SetOperation(s.fakerop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.fakercon2)
	c:RegisterEffect(e3)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function s.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:GetOriginalType()&TYPE_PENDULUM>0
end
function s.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,dg:GetCount(),e:GetHandler())
	Duel.SendtoGrave(cg,REASON_COST)
end
function s.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEUP)
end
function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_HAND,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_HAND,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("你是怎么触发这个效果的？")
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_HAND,nil,tp)
	g:KeepAlive()
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	while tc do
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		end
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(g)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.thop)
	e1:SetLabel(fid)
	Duel.RegisterEffect(e1,tp)   
end
function s.thfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
	if g then
		local sg=g:Filter(s.thfilter,nil,fid)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function s.fakercon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.fakercon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.fakerop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()	
	if c and c:IsFaceup() then
		if KOISHI_CHECK then
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,0))
			local code=c:GetOriginalCode()
			Duel.ResetTimeLimit(tp,233)
			Duel.ResetTimeLimit(1-tp,233)
			--Debug.Message("虽然这是通常怪兽，但是它真的会重置时间")
			for i=0,97 do
				c:SetCardData(CARDDATA_CODE,id+i)
			end
			c:SetCardData(CARDDATA_CODE,code)	 
			Duel.ResetTimeLimit(tp,233)
			Duel.ResetTimeLimit(1-tp,233)
		else
			Debug.Message("请使用koishi端来实现此效果")
		end
	end
end