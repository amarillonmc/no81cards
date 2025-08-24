--隐匿虫 王蝶

local s,id,o=GetID()
local zd=0x3220

function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),3)
	c:EnableReviveLimit()
	--zone limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.zonelimit)
	c:RegisterEffect(e1)
	
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return not c:IsRace(RACE_INSECT) end)
	c:RegisterEffect(e1)
	
	--GraveMzonrTodDeck
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tdatkcon)
	e2:SetTarget(s.tdatktg)
	e2:SetOperation(s.tdatkop) 
	c:RegisterEffect(e2) 
	
	--AtkUpAndDown
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_DRAW) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkudcon)
	e3:SetOperation(s.atkudop) 
	c:RegisterEffect(e3) 
	
	--DestroyAtkZero
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop) 
	c:RegisterEffect(e4) 
	if not s.gcheck then
		s.gcheck=true
		local function op5(e,tp,eg,ep,ev,re,r,rp)
			--ATK = 285, prev ATK = 284
			local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
			for tc in aux.Next(g) do
				if tc:GetFlagEffect(285)==0 then
					local atk=tc:GetAttack()
					if atk<0 then atk=0 end
					tc:RegisterFlagEffect(285,0,0,1,atk)
					tc:RegisterFlagEffect(284,0,0,1,atk)
				end
			end
		end
		local function atkcfilter(c)
			if c:GetFlagEffect(285)==0 then return false end
			return c:GetAttack()~=c:GetFlagEffectLabel(285)
		end
		local function atkraiseeff(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(atkcfilter,tp,0x7f,0x7f,nil)
			local g1=Group.CreateGroup() 
   
			for tc in aux.Next(g) do
				local prevatk=0
				if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
				if prevatk~=0 and tc:GetAttack()==0 then
					g1:AddCard(tc)
				end
				tc:ResetFlagEffect(284)
				tc:ResetFlagEffect(285)
				if prevatk>0 then
					tc:RegisterFlagEffect(284,0,0,1,prevatk)
				else
					tc:RegisterFlagEffect(284,0,0,1,0)
				end
				if tc:GetAttack()>0 then
					tc:RegisterFlagEffect(285,0,0,1,tc:GetAttack())
				else
					tc:RegisterFlagEffect(285,0,0,1,0)
				end
			end
			if #g1>0 then
				Duel.RaiseEvent(g1,EVENT_CUSTOM+id,re,REASON_EFFECT,rp,ep,0)
			end
		end
		local function atkraiseadj(e,tp,eg,ep,ev,re,r,rp)
			if Duel.GetFlagEffect(tp,285)~=0 or Duel.GetFlagEffect(1-tp,285)~=0 then return end
			local g=Duel.GetMatchingGroup(atkcfilter,tp,0x7f,0x7f,nil)
			local g1=Group.CreateGroup()
			for tc in aux.Next(g) do
				local prevatk=0
				if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
				if prevatk~=0 and tc:GetAttack()==0 then
					g1:AddCard(tc)
				end
				tc:ResetFlagEffect(284)
				tc:ResetFlagEffect(285)
				if prevatk>0 then
					tc:RegisterFlagEffect(284,0,0,1,prevatk)
				else
					tc:RegisterFlagEffect(284,0,0,1,0)
				end
				if tc:GetAttack()>0 then
					tc:RegisterFlagEffect(285,0,0,1,tc:GetAttack())
				else
					tc:RegisterFlagEffect(285,0,0,1,0)
				end
			end
			if #g1>0 then
				Duel.RaiseEvent(g1,EVENT_CUSTOM+id,e,REASON_EFFECT,rp,ep,0)
			end
		end
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetOperation(op5)
		Duel.RegisterEffect(e5,0)
		local atkeff=Effect.GlobalEffect()
		atkeff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkeff:SetCode(EVENT_CHAIN_SOLVED)
		atkeff:SetOperation(atkraiseeff)
		Duel.RegisterEffect(atkeff,0)
		local atkadj=Effect.GlobalEffect()
		atkadj:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkadj:SetCode(EVENT_ADJUST)
		atkadj:SetOperation(atkraiseadj)
		Duel.RegisterEffect(atkadj,0)
	end
end 
function s.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end

function s.lkfilter(c)
	return c:IsLinkRace(RACE_INSECT) and c:IsLevelAbove(1)
end

function s.tdatkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.tdatkfilter(c)
	return c:IsSetCard(zd) and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function s.tdatktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdatkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,0)
end
function s.tdatkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdatkfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,99,nil)
	if #g==0 then return end
	local x=0
	for tc in aux.Next(g) do
		Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)
		tc:ReverseInDeck()
		x=x+1
	end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e)) then return end
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(x*200)
	c:RegisterEffect(e1)
end

function s.atkudcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)  
end
function s.atkudop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not (ep~=tp and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)) then return end
	Duel.Hint(HINT_CARD,0,id) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ev*-200)
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
	end 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(ev*200)
	c:RegisterEffect(e1)
end 

function s.descfilter(c)
	return c:IsSetCard(zd) and c:IsReleasableByEffect()
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsAttack(0)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.descfilter,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.descfilter,tp,0,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g2,1,tp,LOCATION_MZONE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.descfilter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e))
	if #rg<=0 then return end
	Duel.HintSelection(rg)
	if Duel.Release(rg,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	Duel.Destroy(tg,REASON_EFFECT)
end
