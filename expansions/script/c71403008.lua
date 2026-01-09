--TETRIS！
---@param c Card
function c71403008.initial_effect(c)
	if not (yume and yume.PPT_loaded) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71403001,0)
		yume.import_flag=false
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403008,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403008.tg1)
	e1:SetOperation(c71403008.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403008)
	yume.PPTCounter()
end
function c71403008.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x715) and not c:IsType(TYPE_LINK)
end
function c71403008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c71403008.filter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 and #g2>0 end
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,LOCATION_ONFIELD)
end
function c71403008.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c71403008.filter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	local lv=0
	if tc:IsType(TYPE_XYZ) then lv=tc:GetRank() else lv=tc:GetLevel() end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if Duel.Destroy(tc,REASON_EFFECT)<1 or #g==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,lv,nil)
	if dg then Duel.Destroy(dg,REASON_EFFECT) end
end