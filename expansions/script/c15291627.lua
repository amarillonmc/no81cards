--爬虫妖女·乌洛波洛斯
function c15291627.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c15291627.spcon)
	e0:SetTarget(c15291627.sptg)
	e0:SetOperation(c15291627.spop)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c15291627.tdtg)
	e1:SetOperation(c15291627.tdop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c15291627.sumsuc)
	c:RegisterEffect(e2)
end
function c15291627.rfilter(c,tp,sc)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(sc)
end
function c15291627.sumfilter(c)
	return c:GetAttack()
end
function c15291627.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c15291627.sumfilter,2000)
end
function c15291627.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(c15291627.rfilter,nil,tp,e:GetHandler())
	return rg:CheckSubGroup(c15291627.fselect,1,rg:GetCount(),tp) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c15291627.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(c15291627.rfilter,nil,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15291627,0))
	local sg=rg:SelectSubGroup(tp,c15291627.fselect,true,1,rg:GetCount(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c15291627.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tp=c:GetControler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	g:DeleteGroup()
end
function c15291627.tdfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x3c)
end
function c15291627.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(c15291627.tdfilter,tp,LOCATION_GRAVE,0,8,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c15291627.tdfilter,tp,LOCATION_GRAVE,0,8,8,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c15291627.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local d=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		if d==8 then 
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,8,REASON_EFFECT)
		end
	end
end
function c15291627.atktg(e,c)
	return not c:IsSetCard(0x3c)
end
function c15291627.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x3c)
end
function c15291627.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	--Atk 0
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(0)
	e2:SetTarget(c15291627.atktg)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	Duel.RegisterEffect(e3,tp)
	--inactivatable
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetValue(c15291627.effectfilter)
	Duel.RegisterEffect(e4,tp)
end
