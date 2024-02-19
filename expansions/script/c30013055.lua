--深土的探寻者
local m=30013055
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_DISCARD)
	e12:SetCountLimit(1,m+100)
	e12:SetTarget(cm.tg2)
	e12:SetOperation(cm.op2)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.tg(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x92c)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,2)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dbg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if #dbg>=2 then
		local dg1=dbg:RandomSelect(tp,2)
		if Duel.SendtoGrave(dg1,REASON_EFFECT+REASON_DISCARD)==2 
			and Duel.IsExistingMatchingCard(cm.tg,tp,LOCATION_DECK,0,2,nil) then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,cm.tg,tp,LOCATION_DECK,0,2,2,nil)
			if #g==2
				and Duel.SendtoGrave(g,REASON_EFFECT)==2
				and c:IsLocation(LOCATION_MZONE) 
				and c:IsAbleToHand() then 
				Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
		end
	end
end
--Effect 2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end


