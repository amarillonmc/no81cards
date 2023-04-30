--黯影魔 毁灭
local m=14060013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,cm.fusfilter1,cm.fusfilter,1,true,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--base attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_BASE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(cm.atkval)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
	--TurnSet
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.tscon)
	e4:SetTarget(cm.tstg)
	e4:SetOperation(cm.tsop)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
end
function cm.fusfilter(c,e,tp)
	return (c:IsFacedown() or (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK))) and c:IsType(TYPE_MONSTER)
end
function cm.fusfilter1(c,e,tp)
	return c:IsFusionSetCard(0x1406) and c:IsType(TYPE_MONSTER)
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.cfilter(c,tp)
	return ((c:IsFusionSetCard(0x1406) or c:IsFacedown() or (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK))) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() 
end
function cm.fcheck(c,sg,tp)
	return c:IsFusionSetCard(0x1406) and (c:IsControler(tp) or c:IsFaceup())and sg:FilterCount(cm.fcheck2,c)+1==sg:GetCount()
end
function cm.fcheck2(c)
	return c:IsFacedown() or (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK))
end
function cm.fgoal(c,tp,sg,fc)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0 and sg:IsExists(cm.fcheck,1,nil,sg,tp)
end
function cm.fselect(c,tp,mg,sg,fc)
	sg:AddCard(c)
	local res=cm.fgoal(c,tp,sg,fc) or mg:IsExists(cm.fselect,1,sg,tp,mg,sg,fc)
	sg:RemoveCard(c)
	return res
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetReleaseGroup(tp):Filter(cm.cfilter,nil,c)
	local mg1=Duel.GetReleaseGroup(1-tp):Filter(cm.cfilter,nil,c)
	mg:Merge(mg1)
	local sg=Group.CreateGroup()
	return mg:IsExists(cm.fselect,1,nil,tp,mg,sg,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetReleaseGroup(tp):Filter(cm.cfilter,nil,c)
	local mg1=Duel.GetReleaseGroup(1-tp):Filter(cm.cfilter,nil,c)
	mg:Merge(mg1)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(cm.fselect,sg,tp,mg,sg,c)
		if cg:GetCount()==0
			or (cm.fgoal(c,tp,sg,c) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.Release(sg,REASON_COST)
end
function cm.atkfilter(c,e,tp)
	return c:IsSetCard(0x1406) and c:IsFaceup()
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*400
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoExtraP(c,tp,REASON_EFFECT)
	end
end
function cm.tscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function cm.tdfilter(c)
	return c:IsSetCard(0x1406) and (c:IsFaceup() and not c:IsExtraDeckMonster()) and (c:IsAbleToDeck() or c:IsAbleToHand())
end
function cm.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #tg>0 then
		local tc=tg:GetFirst()
		if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) and tc:IsAbleToHand() and (not tc:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function cm.efilter(e,re)
	return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and re:GetOwner()~=e:GetOwner()
end