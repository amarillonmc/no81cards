--空间掌控者
function c65840060.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65840060.matfilter,2,4)
	aux.AddCodeList(c,65840000)
	--连接召唤效果
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65840060)
	e1:SetCondition(c65840060.condition1)
	e1:SetTarget(c65840060.target1)
	e1:SetOperation(c65840060.activate1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c65840060.target2)
	e2:SetOperation(c65840060.activate2)
	c:RegisterEffect(e2)
	--无效
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(3,65830016)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65840060.discon)
	e3:SetCost(c65840060.discost)
	e3:SetTarget(c65840060.distg)
	e3:SetOperation(c65840060.disop)
	c:RegisterEffect(e3)
end


function c65840060.matfilter(c)
	return c:IsLinkSetCard(0xa34)
end

function c65840060.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65840060.spfilter(c,e,tp)
	return c:IsSetCard(0xa34) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65840060.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,10,tp,LOCATION_DECK)
end
function c65840060.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetDecktopGroup(tp,10)
	Duel.DisableShuffleCheck()
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c65840060.aclimit)
	Duel.RegisterEffect(e2,tp)
end
function c65840060.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_REMOVED and not re:GetHandler():IsCode(65840000) and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
end


function c65840060.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c65840060.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end

function c65840060.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and ep==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65840060.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEUP)==5
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65840060.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65840060)==0 end
	e:GetHandler():RegisterFlagEffect(65840060,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65840060.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end