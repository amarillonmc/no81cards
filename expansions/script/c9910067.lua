--锦上添花 尤希尔
function c9910067.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910067.lcheck)
	c:EnableReviveLimit()
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9910067)
	e1:SetCondition(c9910067.hacon)
	e1:SetTarget(c9910067.hatg)
	e1:SetOperation(c9910067.haop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9910068)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910067.drcon)
	e2:SetTarget(c9910067.drtg)
	e2:SetOperation(c9910067.drop)
	c:RegisterEffect(e2)
end
function c9910067.lcheck(g)
	return g:IsExists(c9910067.matfilter1,1,nil)
		and g:IsExists(c9910067.matfilter2,1,nil)
end
function c9910067.matfilter1(c)
	return c:IsAttackPos() and c:IsFaceup()
end
function c9910067.matfilter2(c)
	return c:IsDefensePos() and c:IsFaceup()
end
function c9910067.hacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910067.hatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9910067.haop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:RegisterFlagEffect(9910067,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910067.cfilter(c,lg)
	return lg:IsContains(c)
end
function c9910067.drcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return e:GetHandler():GetFlagEffect(9910067)~=0 and eg:IsExists(c9910067.cfilter,1,nil,lg)
end
function c9910067.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910067.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
