--字界眼龙
function c79200001.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c79200001.lkcon)
	e0:SetOperation(c79200001.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79200001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79200001)
	e2:SetTarget(c79200001.thtg)
	e2:SetOperation(c79200001.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79200001,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79200001.tg)
	e3:SetOperation(c79200001.op)
	c:RegisterEffect(e3)
end
function c79200001.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag and c:IsSetCard(0x681)
	elseif c:IsType(TYPE_EQUIP) and c:IsFaceup() then
		return c:GetEquipTarget():IsCode(79200002) and c:IsType(TYPE_SPELL)
	end
end
function c79200001.lvfilter(c)
	if c:IsType(TYPE_EQUIP) and c:IsFaceup() then
		if c:GetEquipTarget():IsCode(79200002) and c:IsType(TYPE_SPELL) then
			return 2
		else 
			return 1 
		end
	else
		return 1 
	end
end
function c79200001.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c79200001.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c79200001.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c79200001.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c79200001.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c79200001.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c79200001.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=3
	if ct>maxc then return false end
	return c79200001.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c79200001.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc) and (not sg or not sg:IsExists(Card.IsLocation,1,c,LOCATION_SZONE)) and Duel.IsExistingMatchingCard(c79200001.cs,tp,LOCATION_MZONE,0,1,nil)
end
function c79200001.cs(c)
	return c:IsSetCard(0x681)
end
function c79200001.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c79200001.lkfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=2
	local maxc=3
	for i=ct,maxc-1 do
		local cg=mg:Filter(c79200001.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c79200001.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		if not sg or not sg:IsExists(Card.IsLocation,1,c,LOCATION_SZONE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			tg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL)
			cg:Sub(tg)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		end
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c79200001.thfilter(c)
	return c:IsSetCard(0x681) and c:IsAbleToHand()
end
function c79200001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function c79200001.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c79200001.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79200001,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c79200001.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end
function c79200001.thfilter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c79200001.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c79200001.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79200001.thfilte1r,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c79200001.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c79200001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c79200001.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c79200001.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end