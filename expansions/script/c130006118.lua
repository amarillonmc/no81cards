--理之座-阿特洛彼斯
local s,id,o=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1109)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1286)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e3:SetCondition(s.atcon)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	if not s.global_flag then
		s.global_flag=true
		s[id+100]={}
		--level
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_UPDATE_LEVEL)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(s.lvfilter)
		ge1:SetValue(s.lvval)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.lvfilter(e,c)
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[id+100]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return ct>0
end
function s.lvval(e,c)
	local ccode=c:GetCode()
	local ct=0
	for _,fcode in ipairs(s[id+100]) do
		if fcode==ccode then
			ct=ct+1
		end
	end
	return -ct
end
function s.thfilter(c)
	return c:IsLevelAbove(1) and c.UnJustice==1 and c:IsAbleToHand()
end
function s.fselect(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not s[130006118] or s[130006118]==0 then return end
	local lv=s[130006118]
	local c=e:GetHandler()
	return c:IsLevelAbove(lv) and Duel.GetFlagEffect(tp,id)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chk==0 then 
		local tun=Duel.GetTurnCount()
		local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)   
	return e:GetHandler():IsAbleToRemoveAsCost() and sg:CheckSubGroup(s.fselect,1,tun,lv) end
	e:SetLabel(lv)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tun=Duel.GetTurnCount()
	local lv=e:GetLabel()
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=sg:SelectSubGroup(tp,s.fselect,false,1,tun,lv)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function s.lvdfilter(c,e)
	return c:IsLevelAbove(2) and c:IsSummonType(SUMMON_TYPE_ADVANCE) and not c:IsImmuneToEffect(e)
end
function s.lvdfilter2(c,e,limt)
	return c:IsLevelAbove(2) and (c:IsSummonType(SUMMON_TYPE_ADVANCE) or limt==1)
		and not c:IsImmuneToEffect(e)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(3)
	local sg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,nil,2)
	local sum=sg:GetSum(Card.GetLevel)
	if sg:IsExists(s.lvdfilter,1,nil,e) then sum=sum+#sg else sum=0 end
	local b2=c:IsLocation(LOCATION_REMOVED) and sum>c:GetLevel()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	e:SetLabel(c:GetLocation())
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local loc=e:GetLabel()
	local limt=0
	local sg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_MZONE,LOCATION_MZONE,nil,2)
	local sum=sg:GetSum(Card.GetLevel)
	if sg:IsExists(s.lvdfilter,1,nil,e) then sum=sum+#sg else sum=0 end
	if loc==LOCATION_MZONE and c:IsFaceup() and c:IsRelateToEffect(e) and lv>2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		if c:GetFlagEffect(id)==0 then
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	elseif loc==LOCATION_REMOVED and c:IsFaceup() and sum>c:GetLevel()
		and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		local mat=Group.CreateGroup()
		for i=1,lv do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			local g=Duel.SelectMatchingCard(tp,s.lvdfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,limt)
			local tc=g:GetFirst()
			if tc:IsSummonType(SUMMON_TYPE_ADVANCE) then limt=1 end
			if tc then
				mat:AddCard(tc)
				table.insert(s[id+100],tc:GetCode())
			end
		end
		c:SetMaterial(mat)
		Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(s.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end