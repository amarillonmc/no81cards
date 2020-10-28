--龙唤士 卡露兹
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005108,"DragonCaller")
function cm.initial_effect(c)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},nil,"td,dr","de",nil,nil,rsop.target({cm.tdfilter,"td",LOCATION_GRAVE },{1,"dr"}),cm.tdop)
	local e3=rsef.STO(c,EVENT_RELEASE,{m,2},nil,"th","de",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
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
function cm.thfilter(c)
	return rsdc.IsSetST(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.tdop(e,tp)
	local tct=0
	if Duel.IsPlayerCanDraw(tp,2) then tct=5 
	elseif Duel.IsPlayerCanDraw(tp,1) then tct=2
	end
	if tct==0 then return end
	if rsop.SelectToDeck(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,1,tct,nil,{})>0 then
		local dct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,rsloc.de)<=2 and 1 or 2
		rsop.ToDeckDraw(tp,dct,true)
	end
end
function cm.tdfilter(c)
	return rsdc.IsSetM(c) and c:IsAbleToDeck()
end
function cm.otfilter(c)
	return rsdc.IsSetM(c) and c:IsAbleToGraveAsCost()
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_DECK,0,nil)
	return c:IsLevelAbove(5) and minc<=1 and #mg>0
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	rsop.SelectToGrave(tp,cm.otfilter,tp,LOCATION_DECK,0,1,1,nil,{REASON_COST })
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
end