--凯尔希·指令 -熔毁-
function c29065626.initial_effect(c)
	aux.AddCodeList(c,29065572)
	c:EnableCounterPermit(0x11ae)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065626.lvtg)
	e1:SetValue(c29065626.lvval)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(29065572)
	c:RegisterEffect(e2)  
	--atklimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(c29065626.atcon)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c29065626.efilter)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29065626,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c29065626.spcon)
	e5:SetTarget(c29065626.sptg)
	e5:SetOperation(c29065626.spop)
	c:RegisterEffect(e5)
	--act limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_RELEASE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c29065626.relcon)
	e6:SetTarget(c29065626.rellimit)
	c:RegisterEffect(e6)
	--atk limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCondition(c29065626.relcon)
	e7:SetValue(c29065626.tgtg)
	c:RegisterEffect(e7)
end
function c29065626.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetCounter(0x11ae)>0 and c:IsSetCard(0x87af)
end
function c29065626.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end
function c29065626.filter(c)
	return c:IsFaceup() and c:IsCode(29065628)
end
function c29065626.atcon(e)
	return Duel.IsExistingMatchingCard(c29065626.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c29065626.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler() and  Duel.IsExistingMatchingCard(c29065626.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c29065626.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065572)
end
function c29065626.spfilter(c,e,tp)
	return c:IsCode(29065628) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c29065626.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29065626.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29065626.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29065626.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c29065626.relcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065572)
end
function c29065626.rellimit(e,c,tp,sumtp)
	return not c:IsCode(29065628)
end
function c29065626.tgtg(e,c)
	return not (c:IsCode(29065628) and c:IsFaceup())
end