--溶 解 王  紫 夜
local m=22348319
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c22348319.distg)
	c:RegisterEffect(e1)
	--half atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(0,EFFECT_FLAG2_WICKED)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22348319.distg)
	e2:SetValue(c22348319.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(c22348319.defval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCondition(c22348319.spcon)
	e4:SetCost(c22348319.spcost)
	e4:SetTarget(c22348319.sptg)
	e4:SetOperation(c22348319.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e5:SetCondition(c22348319.atkcon)
	e5:SetCost(c22348319.spcost)
	e5:SetTarget(c22348319.sptg)
	e5:SetOperation(c22348319.spop)
	c:RegisterEffect(e5)
	--xyz
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c22348319.xyztg) 
	e6:SetOperation(c22348319.xyzop)  
	c:RegisterEffect(e6)
end
function c22348319.xyzfilter(c,e)  
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end  
function c22348319.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(c22348319.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e) end
end  
function c22348319.xyzop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c22348319.xyzfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local tc=g:GetFirst() 
	while tc do
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc)) 
		tc=g:GetNext()
	end  
end 
function c22348319.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c22348319.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c22348319.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348319.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22348320,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_AQUA,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22348320,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_AQUA,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22348319.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22348320,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_AQUA,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22348320,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_AQUA,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp)
	if not (b1 or b2) then return false end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(22348319,1),aux.Stringid(22348319,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(22348319,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(22348319,2))+1
	end
	local p=tp
	if op>0 then p=1-tp end
	local token=Duel.CreateToken(tp,22348320)
	if token and Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c22348319.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function c22348319.seqfilter(c,tc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	return (x1==x2 and math.abs(y1-y2)==1) or (y1==y2 and math.abs(x1-x2)==1)
end
function c22348319.seqfilter2(c)
	return c:IsCode(22348320) or c:IsCode(22348319)
end
function c22348319.distg(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c22348319.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	return g:IsExists(c22348319.seqfilter2,1,nil) and not c:IsCode(22348319)
end
function c22348319.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c22348319.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end