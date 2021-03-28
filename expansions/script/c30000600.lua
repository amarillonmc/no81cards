--邪魂 暗覆侵蚀者 萨洛卡巴
function c30000600.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c30000600.sprcon)
	e1:SetOperation(c30000600.sprop)
	c:RegisterEffect(e1) 
	--Lv Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000600,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c30000600.ccost)
	e2:SetCondition(c30000600.ccon1)
	e2:SetTarget(c30000600.ctg)
	e2:SetOperation(c30000600.cop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c30000600.ccon2)
	c:RegisterEffect(e3)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30000600,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c30000600.ccost1)
	e4:SetCondition(c30000600.ccon3)
	e4:SetTarget(c30000600.ctg2)
	e4:SetOperation(c30000600.cop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c30000600.ccon4)
	c:RegisterEffect(e5)


	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(30000600,2))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,30000600)
	e6:SetOperation(c30000600.op)
	c:RegisterEffect(e6)
end
function c30000600.spcfil(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
end
function c30000600.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	return  rg:GetCount()>4 and rg:IsExists(c30000600.spcfil,1,nil,tp)
end
function c30000600.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,5,5,c)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c30000600.spcfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
		g1:AddCard(c)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,4,4,g1)
		g1:RemoveCard(c)
		g1:Merge(g2)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c30000600.rfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c30000600.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000600.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) and c:GetFlagEffect(30000600)==0 end
	c:RegisterFlagEffect(30000600,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000600.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000600.ccon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000600.ccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000600.filter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c30000600.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000600.filter,tp,LOCATION_MZONE,0,1,nil)
		end
	local ac=Duel.AnnounceLevel(tp,1,12)
	Duel.SetTargetParam(ac)
end

function c30000600.cop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c30000600.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetLabel(ac)
	e2:SetValue(c30000600.xyzlv)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c30000600.xyzlv(e,c,rc)
	if not c:IsLevelAbove(0) then
		return e:GetLabel()
	end
end

function c30000600.rfilter1(c)
	if not c:IsAbleToRemoveAsCost() then return false end
	if c:IsLocation(LOCATION_EXTRA) then 
		return c:IsFaceup() and c:IsAttackAbove(0)
	else
		return c:IsAttackAbove(0)
	end
end
function c30000600.ccost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000600.rfilter1,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(30000601)==0 end
	c:RegisterFlagEffect(30000601,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000600.rfilter1,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000600.ccon3(e,tp,eg,ep,ev,re,r,rp)
	return false
	--return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000600.ccon4(e,tp,eg,ep,ev,re,r,rp)
	return true
	--return Duel.IsPlayerAffectedByEffect(tp,30000010)
end 
function c30000600.ctg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end

function c30000600.cop2(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	Duel.Recover(tp,num,REASON_EFFECT)
end
function c30000600.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,0)
end
function c30000600.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c30000600.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30000600.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end