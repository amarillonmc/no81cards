--幻星龙 风尘
function c35399001.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c35399001.MatFilter,2,true)
--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(35399001,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c35399001.con0)
	e0:SetOperation(c35399001.op0)
	e0:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c35399001.val1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c35399001.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399001,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,35399001)
	e3:SetTarget(c35399001.tg3)
	e3:SetOperation(c35399001.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35399001,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,35399002)
	e4:SetCondition(c35399001.con4)
	e4:SetTarget(c35399001.tg4)
	e4:SetOperation(c35399001.op4)
	c:RegisterEffect(e4)
--
end
--
function c35399001.MatFilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_SYNCHRO) and c:GetLevel()>=8
end
--
function c35399001.cfilter0(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c35399001.MgFilter(sg,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c35399001.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c35399001.cfilter0,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c35399001.MgFilter,2,2,tp,c)
end
function c35399001.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c35399001.cfilter0,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c35399001.MgFilter,false,2,2,tp,c)
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		if tc:IsFacedown() then tg:AddCard(tc) end
	end
	if tg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.Release(sg,REASON_COST)
end
--
function c35399001.val1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c35399001.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if ep==tp and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c35399001.chainlm2)
	end
end
function c35399001.chainlm2(e,rp,tp)
	return tp==rp
end
--
function c35399001.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function c35399001.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
--
function c35399001.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c35399001.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c35399001.op4(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--