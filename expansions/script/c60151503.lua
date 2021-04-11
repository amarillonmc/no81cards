--Blake Belladonna
function c60151503.initial_effect(c)
	c:SetUniqueOnField(1,0,60151503)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c60151503.xyzcon)
	e1:SetOperation(c60151503.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c60151503.rmcon)
	e4:SetTarget(c60151503.rmtg)
	e4:SetOperation(c60151503.rmop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c60151503.spcon1)
	e5:SetTarget(c60151503.sptg)
	e5:SetOperation(c60151503.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(c60151503.spcon2)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c60151503.drcon)
	e7:SetTarget(c60151503.drtg)
	e7:SetOperation(c60151503.drop)
	c:RegisterEffect(e7)
end
function c60151503.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x9b28)
end
function c60151503.xyzfilter1(c,g)
	return g:IsExists(c60151503.xyzfilter2,1,c) and c:IsFaceup() and c:IsSetCard(0x9b28)
end
function c60151503.xyzfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9b28)
end
function c60151503.xyzfilter3(c,g)
	return g:IsExists(c60151503.xyzfilter2,1,c) and c:IsFaceup() and c:IsSetCard(0x9b28) and c:IsLocation(LOCATION_MZONE)
end
function c60151503.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c60151503.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c60151503.mfilter,tp,LOCATION_ONFIELD,0,nil,c)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and (not min or min<=2 and max>=2)
			and mg:IsExists(c60151503.xyzfilter3,1,nil,mg)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and (not min or min<=2 and max>=2)
			and mg:IsExists(c60151503.xyzfilter1,1,nil,mg)
	end
end
function c60151503.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c60151503.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c60151503.mfilter,tp,LOCATION_ONFIELD,0,nil,c)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			g=mg:FilterSelect(tp,c60151503.xyzfilter3,1,1,nil,mg)
			local tc1=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=mg:FilterSelect(tp,c60151503.xyzfilter2,1,1,tc1)
			local tc2=g2:GetFirst()
			g:Merge(g2)
			sg:Merge(tc1:GetOverlayGroup())
			sg:Merge(tc2:GetOverlayGroup())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			g=mg:FilterSelect(tp,c60151503.xyzfilter1,1,1,nil,mg)
			local tc1=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=mg:FilterSelect(tp,c60151503.xyzfilter2,1,1,tc1)
			local tc2=g2:GetFirst()
			g:Merge(g2)
			sg:Merge(tc1:GetOverlayGroup())
			sg:Merge(tc2:GetOverlayGroup())
		end
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

function c60151503.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151503.rmfilter(c)
	return c:IsSetCard(0x9b28)
end
function c60151503.rmfilter2(c)
	return c:IsSetCard(0x9b28) and not c:IsType(TYPE_MONSTER)
end
function c60151503.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:IsExists(c60151503.rmfilter,1,nil) end
end
function c60151503.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(c60151503.rmfilter,nil)
	if g:GetCount()>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			local g2=g:Filter(c60151503.rmfilter2,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g2:Select(tp,1,1,nil)
			local rc=sg:GetFirst()
			if (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
				and rc:IsSSetable() then
				Duel.SSet(tp,rc)
				Duel.ConfirmCards(1-tp,rc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			local rc=sg:GetFirst()
			if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
				Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,rc)
			elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
				and rc:IsSSetable() then
				Duel.SSet(tp,rc)
				Duel.ConfirmCards(1-tp,rc)
			end
		end
	end
end
function c60151503.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and rp==1-tp 
end
function c60151503.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.GetAttacker():IsControler(1-tp)
end
function c60151503.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60151599,0,0x4011,1500,1500,4,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60151503.ofilter(c)
	return c:IsFaceup() and c:IsCode(60151599)
end
function c60151503.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60151599,0,0x4011,1500,1500,4,RACE_WARRIOR,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,60151599)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c60151503.ofilter,tp,LOCATION_MZONE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				local tc=g:GetFirst()
				local a=Duel.GetAttacker()
				if a then
					local ag=a:GetAttackableTarget()
					if a:IsAttackable() and not a:IsImmuneToEffect(e) and ag:IsContains(tc) then
						Duel.ChangeAttackTarget(tc)
					end
				else
					Duel.ChangeTargetCard(ev,Group.FromCards(tc))
				end
			end
		end
	end
end
function c60151503.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsCode(60151599)
end
function c60151503.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151503.cfilter,1,nil,tp)
end
function c60151503.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60151503.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end