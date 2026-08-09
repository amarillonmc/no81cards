--骰子女神 阿赖耶
function c91300081.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c91300081.mfilter,nil,2,283)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	--e1:SetCost(c91300081.costchk)
	e1:SetTarget(c91300081.costtg)
	e1:SetOperation(c91300081.costop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c91300081.cpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c91300081.cptg)
	e2:SetOperation(c91300081.cpop)
	c:RegisterEffect(e2)
	--
	if not c91300081.global_check then
		c91300081.global_check=true
		local _TossDice=Duel.TossDice
		function Duel.TossDice(p,d1,...)
			local ct=... and d1+... or d1
			if ct and ct>0 then for i=1,ct do Duel.RegisterFlagEffect(0,91300082,RESET_PHASE+PHASE_END,0,1) end end 
			return _TossDice(p,d1,...)
		end
	end
	if not CROSSROADS_ENTITY then
		CROSSROADS_ENTITY = true
		Crossroads_card_list={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c91300081.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91300081.mfilter(c,xyzc)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
function c91300081.regop(e,tp,eg,ep,ev,re,r,rp)
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Duel.CreateToken(0,code)
		Crossroads_card_list[code]=tc
	end
end
function c91300081.tgfilter(c)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and c:IsAbleToGrave()
end
function c91300081.costchk(e,te_or_c,tp)
	return Duel.GetFlagEffect(tp,91300081)==0 and Duel.IsExistingMatchingCard(c91300081.tgfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToGrave()
end
function c91300081.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te:GetDescription()==aux.Stringid(9300420,0) or te:GetHandler():IsOriginalCodeRule(33701339,91300067,91300073)--false--te:IsHasProperty(EFFECT_FLAG_DICE)
end
function c91300081.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,91300081)==0 and Duel.IsExistingMatchingCard(c91300081.tgfilter,tp,LOCATION_HAND,0,1,te:GetHandler()) and e:GetHandler():IsAbleToGrave() and c91300081.used_e~=e:GetLabelObject() and Duel.SelectYesNo(tp,aux.Stringid(91300081,2)) then
		c91300081.used_e=e:GetLabelObject()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c91300081.tgfilter,tp,LOCATION_HAND,0,1,1,te:GetHandler())
		g:AddCard(e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
		local d1,d2=0,0
		while d1==d2 do
			for p in aux.TurnPlayers() do
				local dc=Duel.TossDice(p,1)
				if p==tp then d1=dc else d2=dc end
			end
		end
		local p=d1>d2 and tp or 1-tp
		c91300081.drop(e,p,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(1-p,91300081,RESET_PHASE+PHASE_END,0,1)
	end
end
function c91300081.thfilter(c)
	return c:IsSetCard(0x855) and c:IsAbleToHand()
end
function c91300081.drop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c91300081.thfilter,tp,LOCATION_DECK,0,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(91300081,0)},
		{b2,aux.Stringid(91300081,1)})
	if op==1 then
		Duel.Draw(tp,2,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c91300081.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c91300081.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,91300082)>=6
end
function c91300081.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=false
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if code~=e:GetHandler():GetCode() and tc:CheckActivateEffect(false,true,false)~=nil then res=true break end
	end
	if chk==0 then return res and Duel.GetFlagEffect(tp,91300081)==0 end
end
function c91300081.cpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,91300081)~=0 then return end
	local codes={}
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if tc:CheckActivateEffect(false,true,false)~=nil then
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
