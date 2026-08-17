--歧路诗篇－喧闹墓地－
function c91300065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91300065,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300065.target)
	e1:SetOperation(c91300065.activate)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c91300065.coinop)
	c:RegisterEffect(e2)
	--
	if not CROSSROADS_COIN then
		CROSSROADS_COIN = true
		Crossroads_coin_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300065.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300065.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_coin_effect_list={}
end
function c91300065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c91300065.obverse(e,tp,eg,ep,ev,re,r,rp,0) or c91300065.reverse(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c91300065.activate(e,tp,eg,ep,ev,re,r,rp)
	Dead_Town_99_Check=true--coin;91300063
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		if e:IsActivated() then
			Crossroads_coin_effect_list[aux.Stringid(91300065,1)]=c91300065.reverse
		end
		c91300065.obverse(e,tp,eg,ep,ev,re,r,rp,1)
	else
		if e:IsActivated() then
			Crossroads_coin_effect_list[aux.Stringid(91300065,0)]=c91300065.obverse
		end
		c91300065.reverse(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c91300065.tgfilter(c)
	return (c:IsSetCard(0x855) and not c:IsCode(91300065) or c:IsOnField()) and c:IsAbleToGrave()
end
function c91300065.gcheck(g,p)
	return #g==1 and g:FilterCount(Card.IsControler,nil,p)==1 or g:FilterCount(Card.IsOnField,nil)==2
end
function c91300065.thfilter(c)
	if not c:IsAbleToHand() then return false end
	local b1=c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and Duel.GetFlagEffect(0,91300064)==0
	local b2=c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) and Duel.GetFlagEffect(0,91300065)==0
	local b3=c:IsCode(9300420,10173087,33701339,91300067,91300073,91300079) and Duel.GetFlagEffect(0,91300066)==0
	return b1 or b2 or b3
end
function c91300065.obverse(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c91300065.tgfilter,tp,LOCATION_DECK,LOCATION_ONFIELD,nil)
	if chk==0 then
		return g:CheckSubGroup(c91300065.gcheck,1,2,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:SelectSubGroup(tp,c91300065.gcheck,false,1,2,tp)
		if tg:GetCount()>0 then
			Duel.HintSelection(tg)
			Duel.SendtoGrave(tg,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:IsExists(c91300065.thfilter,1,nil) and c91300065.reverse(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(91300065,2)) then
				Duel.BreakEffect()
				Duel.SendtoHand(og:Filter(c91300065.thfilter,nil),nil,REASON_EFFECT)
				for tc in aux.Next(og) do
					if tc:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) then
						Duel.RegisterFlagEffect(0,91300064,RESET_PHASE+PHASE_END,0,1)
					elseif tc:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_COIN)) then
						Duel.RegisterFlagEffect(0,91300065,RESET_PHASE+PHASE_END,0,1)
					elseif tc:IsCode(9300420,10173087,33701339,91300067,91300073,91300079) then
						Duel.RegisterFlagEffect(0,91300066,RESET_PHASE+PHASE_END,0,1)
					end
				end
				c91300065.reverse(e,tp,eg,ep,ev,re,r,rp,1)
			end
		end
	end
end
function c91300065.reverse(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	if CROSSROADS_DICE then
		for des,f in pairs(Crossroads_dice_effect_list) do
			local res=f(e,tp,eg,ep,ev,re,r,rp,0)
			if res then
				for _,v in pairs(t) do
					if v==des then res=false end
				end
			end
			if res then table.insert(t,des) end
		end
		for des,_ in pairs(Crossroads_dice_except_list) do table.remove(t,des) end
	end
	if chk==0 then
		return #t>0
	else
		if #t>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
			local sel=Duel.SelectOption(tp,table.unpack(t))
			local des=t[sel+1]
			local f=Crossroads_dice_effect_list[des]
			f(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c91300065.coinop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.Hint(HINT_CARD,0,91300065)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TOSS_COIN_NEGATE)
		e1:SetOperation(c91300065.repop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91300065.repop(e,tp,eg,ep,ev,re,r,rp)
	local cc={Duel.GetCoinResult()}--maybe exist 0!
	local t={}
	for i,v in ipairs(cc) do
		if v==0 then table.insert(t,i) end
	end
	Duel.SetCoinResult(table.unpack(cc))
	if #t~=0 and Duel.SelectYesNo(tp,aux.Stringid(91300065,3)) then
		Duel.Hint(HINT_CARD,0,91300065)
		local ac=t[1]
		if #t>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91300065,4))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		cc[ac]=1
		Duel.SetCoinResult(table.unpack(cc))
		e:Reset()
	end
end
