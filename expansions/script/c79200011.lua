--字界眼国公主
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.lkcon)
	e0:SetOperation(s.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(s.indcon)
	e2:SetOperation(s.indop)
	c:RegisterEffect(e2)
end
function s.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag
	elseif c:IsType(TYPE_EQUIP) and c:IsFaceup() then
		return c:GetEquipTarget():IsSetCard(0x681) and c:GetEquipTarget():IsType(TYPE_EFFECT) and c:IsType(TYPE_SPELL)
	end
end
function s.lvfilter(c)
	if c:IsType(TYPE_EQUIP) and c:IsFaceup() then
		if c:GetEquipTarget():IsSetCard(0x681) and c:GetEquipTarget():IsType(TYPE_EFFECT) and c:IsType(TYPE_SPELL) then
			return 2
		else 
			return 1 
		end
	else
		return 1 
	end
end
function s.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(s.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function s.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=s.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(s.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function s.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=2
	if ct>maxc then return false end
	return s.lcheck(tp,sg,c,minc,ct) or mg:IsExists(s.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc) and (not sg or not sg:IsExists(Card.IsLocation,1,c,LOCATION_SZONE)) and Duel.IsExistingMatchingCard(s.cs,tp,LOCATION_MZONE,0,1,nil)
end
function s.cs(c)
	return c:IsSetCard(0x681)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=2
	for i=ct,maxc-1 do
		local cg=mg:Filter(s.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		local zbg=cg:Filter(s.zbg,sg,c,tp)
		if cg:GetCount()==0 then break end
		local minct=1
		if s.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		if not sg or not sg:IsExists(Card.IsLinkSetCard,1,nil,0x681) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=zbg:Select(tp,minct,1,nil)
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
function s.zbg(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag and c:IsSetCard(0x681)
	elseif c:IsType(TYPE_EQUIP) and c:IsFaceup() then
		return c:GetEquipTarget():IsSetCard(0x681) and c:GetEquipTarget():IsType(TYPE_EFFECT) and c:IsType(TYPE_SPELL)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.tgfilter(c)
	return c:IsSetCard(0x681) and c:IsAbleToGrave() and c:IsType(TYPE_EFFECT)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK or r==REASON_FUSION or r==REASON_XYZ or r==REASON_SYNCHRO 
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(s.indval)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function s.indval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end