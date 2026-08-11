--歧路诗篇－死城市街－
function c91300063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300063.target)
	e1:SetOperation(c91300063.activate)
	c:RegisterEffect(e1)
	if not CROSSROADS_ENTITY then
		CROSSROADS_ENTITY = true
		Crossroads_card_list={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c91300063.regop)
		Duel.RegisterEffect(ge1,0)
	end
	if not c91300063.global_check then
		c91300063.global_check=true
		c91300063.dice_sum={}
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TOSS_DICE_NEGATE)
		ge2:SetOperation(c91300063.sumop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(function (e,tp,eg,ep,ev,re,r,rp) c91300063.dice_sum={} Dead_Town_99_Check=false end)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHAIN_SOLVING)
		Duel.RegisterEffect(ge4,0)
	end
end
function c91300063.regop(e,tp,eg,ep,ev,re,r,rp)
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Duel.CreateToken(0,code)
		Crossroads_card_list[code]=tc
	end
end
function c91300063.thfilter(c,chk)
	return c:IsSetCard(0x855) and c:IsAbleToHand()
end
function c91300063.acfilter(c,tp)
	return c:IsSetCard(0x855) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c91300063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c91300063.thfilter,tp,LOCATION_DECK,0,1,nil,0)
	local b2=false
	local b3=c91300063.cptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b4=Duel.IsExistingMatchingCard(c91300063.acfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b5=Duel.IsPlayerCanDraw(tp,2)
	--local b6=false
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c91300063.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
		c91300063.thop(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==2 then
		c91300063.activate(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==3 then
		c91300063.cpop(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==4 then
		c91300063.acop(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==5 then
		c91300063.drop(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==6 then
		local b1=Duel.IsExistingMatchingCard(c91300063.thfilter,tp,LOCATION_DECK,0,1,nil,0)
		local b2=true
		local b3=c91300063.cptg(e,tp,eg,ep,ev,re,r,rp,0)
		local b4=Duel.IsExistingMatchingCard(c91300063.acfilter,tp,LOCATION_DECK,0,1,nil,tp)
		local b5=Duel.IsPlayerCanDraw(tp,2)
		local f=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(91300063,0),c91300063.thop},
			{b2,aux.Stringid(91300063,1),c91300063.activate},
			{b3,aux.Stringid(91300063,2),c91300063.cpop},
			{b4,aux.Stringid(91300063,3),c91300063.acop},
			{b5,aux.Stringid(91300063,4),c91300063.drop})
		f(e,tp,eg,ep,ev,re,r,rp)
		return
	elseif dc==99 then
		if Dead_Town_99_Check then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-c91300063.dice_sum[e]*200)
		end
	end
end
function c91300063.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c91300063.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c91300063.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=false
	for _,code in pairs({91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if tc:CheckActivateEffect(false,true,false)~=nil then res=true break end
	end
	if chk==0 then return res end
end
function c91300063.cpop(e,tp,eg,ep,ev,re,r,rp)
	local codes={}
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if code~=e:GetHandler():GetCode() and tc:CheckActivateEffect(false,true,false)~=nil then
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	local tc=Crossroads_card_list[ac]
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(0)--Original Property
end
function c91300063.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c91300063.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c91300063.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c91300063.sumop(e,tp,eg,ep,ev,re,r,rp)
	for _,v in ipairs({Duel.GetDiceResult()}) do
		c91300063.dice_sum[re]=c91300063.dice_sum[re]+v
	end
end
