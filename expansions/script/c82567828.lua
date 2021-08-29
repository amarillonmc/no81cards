--方舟騎士·硬币弹匣 杰西卡
function c82567828.initial_effect(c)
	--Summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567828,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,82567828+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c82567828.thcon)
	e1:SetTarget(c82567828.thtg)
	e1:SetOperation(c82567828.thop)
	c:RegisterEffect(e1)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,82567928+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c82567828.thcon)
	e3:SetTarget(c82567828.dwtg)
	e3:SetOperation(c82567828.dwop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567828.dwfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567828.dwfilter2(c)
	return not c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567828.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567828.dwfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		  and not Duel.IsExistingMatchingCard(c82567828.dwfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567828.thfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c82567828.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567828.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c82567828.thfilter,1,tp,LOCATION_GRAVE)
end
function c82567828.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567828.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82567828.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c82567828.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end