--猎蜂·罗德厨房收藏-掠蜜能手
function c79029337.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c79029337.mfilter,aux.TRUE,1,99,true) 
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029146)
	c:RegisterEffect(e2)	 
	--hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029337)
	e1:SetCondition(c79029337.lzcon)
	e1:SetTarget(c79029337.lztg)
	e1:SetOperation(c79029337.lzop)
	c:RegisterEffect(e1) 
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c79029337.atcon)
	e3:SetCost(c79029337.atcost)
	e3:SetOperation(c79029337.atop)
	c:RegisterEffect(e3)			
end
function c79029337.mfilter(c)
	return c:IsLinkSetCard(0xa900) and c:IsLinkType(TYPE_LINK)
end
function c79029337.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029337.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetMaterialCount()
	if chk==0 then return x>0 and Duel.IsPlayerCanDraw(tp,x) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,x-1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
end
function c79029337.lzop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("好！打赢之后我请各位吃饭！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029337,0))
	local x=e:GetHandler():GetMaterialCount()
	if Duel.Draw(tp,x,REASON_EFFECT) then
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local dg=g:FilterSelect(tp,Card.IsAbleToDeck,x-1,x-1,nil)
	Duel.SendtoDeck(dg,tp,2,REASON_EFFECT)
	end
end
function c79029337.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0)
end
function c79029337.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c79029337.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
	Debug.Message("打打打打打！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029337,1))
end







