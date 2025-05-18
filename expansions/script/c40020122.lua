--恐乐园的诱待人 ＜H丑角＞
local m=40020122
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.eqcon)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)

end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x15b)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and c:IsControler(tp)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:GetEquipGroup():IsExists(cm.cfilter,1,nil,tp),true
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsCode(70389815) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.eqcfilter(c,tp)
	local tc=c:GetEquipTarget()
	return tc and c:IsSetCard(0x15c) and c:IsType(TYPE_TRAP) and c:GetControler() == tp
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.eqcfilter,1,nil,tp)
end
function cm.filter1(c)
	return c:IsSetCard(0x15b) and c:IsSummonable(true,nil)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	--local g1=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	--local g2=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return #g1>0 or #g2>0 end
	e:SetCategory(0)
	local off=1
	local ops={}
	local opval={}
	if #g1>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off]=0
		off=off+1
	end
	if #g2>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)

	if sel==0 then
		e:SetCategory(CATEGORY_SUMMON)
		--if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	elseif sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		--if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end

end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc1 then
			Duel.Summon(tp,tc1,true,nil)
		end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
		local ec=tc2:GetEquipTarget()
		if tc2 then
			--Duel.HintSelection(tc2)
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			if tc2:IsType(TYPE_TRAP) and tc2:IsControler(tp) and tc2:IsSetCard(0x15c) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.BreakEffect()
				--local ec=tc2:GetEquipTarget()
				if ec then
					Duel.SendtoHand(ec,nil,REASON_EFFECT)
				end
			end
		end
	end
end
