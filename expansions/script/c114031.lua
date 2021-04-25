--扭曲念想·不死的黑蛇
function c114031.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114031.sprcon)
	e2:SetOperation(c114031.sprop)
	c:RegisterEffect(e2) 
	--Announce
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)   
	e3:SetCountLimit(1)
	e3:SetTarget(c114031.antg)
	e3:SetOperation(c114031.anop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(114031,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c114031.seqtg)
	e4:SetOperation(c114031.seqop)
	c:RegisterEffect(e4)
end
function c114031.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec end
end
function c114031.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
-----
function c114031.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c114031.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c114031.sprfilter2,1,c,tp,c,sc,lv)
end
function c114031.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c114031.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c114031.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c114031.sprfilter1,1,nil,tp,g,c)
end
function c114031.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c114031.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c114031.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c114031.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c114031.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114031,3))
	op=Duel.SelectOption(tp,aux.Stringid(114031,0),aux.Stringid(114031,1),aux.Stringid(114031,2))
	e:SetLabel(op)
end
function c114031.anop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(op)
	e1:SetCondition(c114031.eqcon)
	e1:SetOperation(c114031.eqop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c114031.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if op==0 then 
	return ((ex2 and bit.band(dv2,LOCATION_DECK)==LOCATION_DECK) or (ex2 and bit.band(dv2,LOCATION_EXTRA)==LOCATION_EXTRA)) and rp==1-tp and Duel.IsChainDisablable(ev) and re:GetHandler():IsType(TYPE_MONSTER)
	elseif op==1 then
	return (ex2 and bit.band(dv2,LOCATION_GRAVE)==LOCATION_GRAVE) and rp==1-tp and Duel.IsChainDisablable(ev) and re:GetHandler():IsType(TYPE_MONSTER)
	elseif op==2 then
	return (ex2 and bit.band(dv2,LOCATION_HAND)==LOCATION_HAND) and rp==1-tp and Duel.IsChainDisablable(ev) and re:GetHandler():IsType(TYPE_MONSTER) 
	end
end
function c114031.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,114031)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if c:IsOnField() and c:IsFaceup() and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
	if tc:IsLocation(LOCATION_MZONE) then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c114031.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)  
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)  
	 elseif not tc:IsLocation(LOCATION_MZONE) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c114031.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)  
	end 
	end
	e:Reset()
end
function c114031.eqlimit(e,c)
	return e:GetOwner()==c
end







