--机皇帝-智帝∞
function c9981621.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981621,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9981621.spcon)
	e2:SetTarget(c9981621.sptg)
	e2:SetOperation(c9981621.spop)
	c:RegisterEffect(e2)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981621,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9981621.eqcon)
	e1:SetTarget(c9981621.eqtg)
	e1:SetOperation(c9981621.eqop)
	c:RegisterEffect(e1)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c9981621.adcon)
	e4:SetValue(c9981621.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetCondition(c9981621.adcon)
	e5:SetValue(c9981621.defval)   
	c:RegisterEffect(e5)
--equip fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c9981621.mttg)
	e3:SetValue(c9981621.mtval)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981621.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981621.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981621,0))
end 
function c9981621.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and bit.band(c:GetReason(),0x41)==0x41 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c9981621.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981621.filter,1,nil,tp)
end
function c9981621.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981621.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function c9981621.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c9981621.can_equip_monster(c)
end
function c9981621.eqfilter(c)
	return c:GetFlagEffect(9981621)~=0 
end
function c9981621.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c9981621.eqfilter,nil)
	return g:GetCount()==0
end
function c9981621.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9981621.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9981621.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(9981621,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9981621.eqlimit)
	tc:RegisterEffect(e1)
	--substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(c9981621.repval)
	tc:RegisterEffect(e2)	   
end
function c9981621.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		c9981621.equip_monster(c,tp,tc)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981621,0))
end
function c9981621.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c9981621.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c9981621.eqfilter,nil)
	return g:GetCount()>0
end
function c9981621.atkval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c9981621.eqfilter,nil)
	local atk=g:GetFirst():GetTextAttack()
	if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
		return 0
	else
		return atk
	end
end
function c9981621.defval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c9981621.eqfilter,nil)
	local def=g:GetFirst():GetTextDefense()
	if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or def<0 then
		return 0
	else
		return def
	end
end
function c9981621.mttg(e,c)
	return c:GetEquipTarget()==e:GetHandler()
end
function c9981621.mtval(e,c)
	if not c then return false end
	return c:IsRace(RACE_MACHINE)
end