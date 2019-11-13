--KDA-至臻阿卡丽
function c9981577.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9981573,aux.FilterBoolFunction(Card.IsFusionType,TYPE_XYZ),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981577,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9981577)
	e1:SetTarget(c9981577.thtg)
	e1:SetOperation(c9981577.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981577.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9981577,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(aux.bdocon)
	e5:SetTarget(c9981577.efftg)
	e5:SetOperation(c9981577.effop)
	c:RegisterEffect(e5)
end
function c9981577.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981577,0))
end
function c9981577.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c9981577.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981577.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981577.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981577.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9981577.filter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c9981577.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0
	local b3=Duel.IsExistingMatchingCard(c9981577.filter,tp,LOCATION_GRAVE,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(9981577,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9981577,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9981577,3)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(9981577,4)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
	elseif sel==2 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	elseif sel==3 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	end
end
function c9981577.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif sel==2 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9981577.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
	   if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981577,0))
end