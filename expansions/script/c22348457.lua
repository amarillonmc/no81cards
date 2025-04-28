--渊杀士 瑰月
local m=22348457
local cm=_G["c"..m]
function cm.initial_effect(c)
	yss_effect_table={}
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348457,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,22348457)
	e1:SetTarget(c22348457.sptg)
	e1:SetOperation(c22348457.spop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348457,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	e2:SetTarget(c22348457.fptg)
	e2:SetOperation(c22348457.fpop)
	c:RegisterEffect(e2) 
	
end
function c22348457.cpfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
end
function c22348457.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22348457.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348457.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c22348457.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348457.seteffect(code)
	if not yss_effect_table[code] then
	cregister=Card.RegisterEffect
	table_effect={}
	Card.RegisterEffect=function(card,effect,flag)
		if effect and effect:IsHasType(EFFECT_TYPE_SINGLE) and effect:IsHasType(EFFECT_TYPE_FLIP) then
			local eff=effect:Clone()
			table.insert(table_effect,eff)
		end
		return 
	end
	Duel.CreateToken(1,code)
	Card.RegisterEffect=cregister
	yss_effect_table[code]=table_effect
	end
end
function c22348457.spop(e,tp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
		c22348457.seteffect(tc:GetOriginalCode())
		e:SetLabel(tc:GetOriginalCode())
		end
	end
end
function c22348457.fptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ccode=e:GetLabelObject():GetLabel()
	local fetable=yss_effect_table[ccode]
	if chk==0 then 
		if not fetable or #fetable<=0 then return false end
		for k,v in ipairs(fetable) do
			if v then
				local tg=v:GetTarget()
				if not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0)) then return true end
			end
		end
		return false
	end
	local optable={}
	local off=1
	local ops={}
	for k,v in ipairs(fetable) do
		if v then
			local tg=v:GetTarget()
			if not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0)) then 
				table.insert(optable,v)
				ops[off]=v:GetDescription()
				off=off+1
			end
		end
	end
	if #optable<=0 then return false end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local seleff=optable[op+1]:Clone()
	Duel.ClearTargetCard()
	e:SetLabelObject(seleff)
	local tg=seleff:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c22348457.fpop(e,tp,eg,ep,ev,re,r,rp)
	local eff=e:GetLabelObject()
	if eff then
		local op=eff:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348457,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end

