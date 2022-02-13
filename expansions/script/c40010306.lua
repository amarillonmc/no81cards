--七星之轮回
local m=40010306
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.drawtg)
	e1:SetOperation(cm.drawop)
	c:RegisterEffect(e1)	
end
function cm.cfilter(c)
	return (c:IsLevel(5) or c:IsRank(5)) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function cm.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_COST)>0 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 and tc:IsSetCard(0x52) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end