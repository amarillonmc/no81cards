--八岐大狐
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010101
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"dr","de,dsp",rscon.sumtype("link"),nil,cm.drtg,cm.drop)
	local e2=rsef.SV_IMMUNE_EFFECT(c,cm.val)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,1},1,"res,neg,des","dcal,dsp",LOCATION_MZONE,rscon.negcon(0),nil,cm.negtg,cm.negop)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()  
	local lg=c:GetLinkedGroup()
	if chk==0 then return lg:IsExists(Card.IsReleasable,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetRelationThisCard(e)
	if not c then return end
	local lg=c:GetLinkedGroup()
	if #lg<=0 then return end
	rsof.SelectHint(tp,"res")
	local rg=lg:FilterSelect(tp,Card.IsReleasable,1,1,nil)
	if #rg<=0 or Duel.Release(rg,REASON_EFFECT)<=0 or not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.val(e,re)
	return rsval.imoe(e,re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetLink()
	local matct=e:GetHandler():GetMaterialCount()
	local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct and ct>0 and Duel.IsPlayerCanDraw(tp,ct) and hct+ct>=matct end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.drop(e,tp)
	local c=rscf.GetRelationThisCard(e)
	if not c then return end
	local ct=c:GetLink()
	local matct=e:GetHandler():GetMaterialCount()
	if not ct or ct==0 or Duel.Draw(tp,ct,REASON_EFFECT)<=0 then return end
	local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if hct<matct then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,matct,matct,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end