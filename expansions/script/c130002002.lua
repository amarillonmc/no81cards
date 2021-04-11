--大天之龙战士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002002)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"se,th,sum",nil,LOCATION_HAND,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},nil,"tg",LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToHandAsCost,"th"),rstg.target(cm.tgfilter,nil,LOCATION_MZONE),cm.tgop)
end
function cm.tgfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.tgop(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	tc:RegisterFlagEffect(m,rsreset.est,0,1)
	local e1=rsef.FV_LIMIT_PLAYER({c,tp},"sp",nil,cm.lstg,{0,1},cm.lcon)
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"act",cm.lval,nil,{0,1},cm.lcon)
end
function cm.lstg(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function cm.lval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function cm.lcfilter(c)
	return c:GetFlagEffect(m)>0
end
function cm.lcon(e)
	if Duel.IsExistingMatchingCard(cm.lcfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.thfilter(c)
	return c:IsSummonableCard() and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local c=e:GetHandler()
	local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	tc:RegisterEffect(e1,true)
	local e2=rsef.RegisterClone({c,tc},e1,"code",EFFECT_SET_PROC)
	local pos=0
	if tc:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if tc:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 or not rsop.SelectYesNo(tp,{m,3}) then return end
	Duel.BreakEffect()
	if Duel.SelectPosition(tp,tc,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,tc,true,nil,1)
	else
		Duel.MSet(tp,tc,true,nil,1)
	end
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsLevelAbove(5) and minc<=1 and Duel.IsPlayerCanDiscardDeckAsCost(1-tp,c:GetLevel())
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetMaterial(Group.CreateGroup())
	Duel.DiscardDeck(1-tp,c:GetLevel(),REASON_COST+REASON_SUMMON)
	e:Reset()
end
