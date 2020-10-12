--星光歌剧 凤满
if not pcall(function() require("expansions/script/c65010000") end) then require("script/c65010000") end
local m,cm=rscf.DefineCard(65010585)
function cm.initial_effect(c)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},{1,m},"dish,se,th","de",rscon.sumtype("adv"),nil,rsop.target({2,"dish"},{cm.thfilter,"th",LOCATION_DECK }),cm.thop)
	local e3=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,2},{1,m},"td,des","de",rscon.sumtype("adv"),nil,rsop.target2(cm.fun,cm.tdfilter,"td",0,LOCATION_ONFIELD),cm.tdop)
	local e4=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,3},{1,m},"dish,dr","de",rscon.sumtype("adv"),nil,rsop.target({cm.dishfilter,"dish",LOCATION_HAND,0,1},{1,"dr"}),cm.drop)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)	
end
function cm.otfilter(c)
	return c:IsSetCard(0x9da0) and c:IsAbleToRemoveAsCost()
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_EXTRA,0,nil)
	return c:IsLevelAbove(5) and minc<=1 and #mg>0
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	rsop.SelectRemove(tp,cm.otfilter,tp,LOCATION_EXTRA,0,1,1,nil,{POS_FACEUP,REASON_COST })
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9da0) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if rsop.SelectToGrave(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,2,2,{REASON_DISCARD+REASON_EFFECT },REASON_EFFECT)>0 then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function cm.tdfilter(c,e,tp)
	return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,c:GetEquipGroup())
end
function cm.tdop(e,tp)
	local ct,og,tc=rsop.SelectToDeck(tp,cm.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil,{},e,tp)
	if tc and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		rsop.SelectOC(nil,true)
		rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil,{})
	end
end
function cm.dishfilter(c)
	return c:IsDiscardable(REASON_EFFECT) and c:IsSetCard(0x9da0)
end
function cm.drop(e,tp)
	if rsop.SelectToGrave(tp,cm.dishfilter,tp,LOCATION_HAND,0,1,1,nil,{REASON_EFFECT+REASON_DISCARD })>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end