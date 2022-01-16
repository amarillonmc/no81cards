--虚拟YouTuber 梓璃梦 ～完全复活～
function c33701347.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701347,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER+CATEGORY_CONTROL+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33701347.destg)
	e1:SetOperation(c33701347.desop)
	c:RegisterEffect(e1)
end
function c33701347.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c33701347.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33701347.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,0,0)
end
function c33701347.cfilter(c)
	return c:IsControlerCanBeChanged() and c:GetFlagEffect(33701347)>0
end
function c33701347.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33701347.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local  reg=Duel.SelectMatchingCard(tp,c33701347.filter,tp,LOCATION_GRAVE,0,1,Duel.GetLocationCount(tp,LOCATION_MZONE),nil)
		if Duel.Remove(reg,POS_FACEUP,REASON_EFFECT)~=0 then
			local dg=Duel.GetOperatedGroup()
			local num=dg:GetCount()
			if num>0 then
				local change=num*500
				local mg=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
				for tc in aux.Stringid(mg) do
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(EFFECT_UPDATE_ATTACK)
					e0:SetValue(-change)
					tc:RegisterEffect(e0)
					local e1=e0:Clone()
					e1:SetCode(EFFECT_UPDATE_DEFENSE)
					tc:RegisterEffect(e1)
					if tc:IsAttack(0) or tc:IsDefense(0) then
						tc:RegisterFlagEffect(33701347,RESET_CHAIN,0,1)
					end
				end
				local cg=Duel.GetMatchingGroup(c33701347.cfilter,tp,0,LOCATION_MZONE,nil)
				local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local temp=cg:GetCount()
				lc=math.min(lc,temp)
				for i=1,tc do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
					local cc=cg:Select(tp,1,1,nil)
					Duel.GetControl(cc,tp)
				end
			end
		end
	end
end