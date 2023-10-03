--幻异梦境-蔷薇教堂
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400059.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400059,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,71400059)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c71400059.op1)
	c:RegisterEffect(e1)
	--activate field
	yume.AddYumeFieldGlobal(c,71400059,1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(71400059,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,71500059)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c71400059.con3)
	e3:SetTarget(c71400059.tg3)
	e3:SetOperation(c71400059.op3)
	c:RegisterEffect(e3)
end
function c71400059.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c71400059.xyztg)
	e1:SetValue(c71400059.xyzlv)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c71400059.xyztg(e,c)
	return not c:IsLevel(4) and c:IsSetCard(0x714)
end
function c71400059.xyzlv(e,c,rc)
	return 0x40000+c:GetLevel()
end
function c71400059.filter3a(c)
	return c:IsType(TYPE_XYZ) and (c:IsPreviousPosition(POS_FACEUP) or c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:GetOverlayGroup():IsExists(c71400059.filter3b,1,nil)
end
function c71400059.filter3b(c)
	return c:IsSetCard(0x714) and not (c:IsType(TYPE_MONSTER) and c:IsLevel(4))
end
function c71400059.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71400059.filter3a,1,nil) and rp==1-tp
end
function c71400059.filter3c(c,e,tp)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400059.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400059.filter3c(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanOverlay() and Duel.IsExistingTarget(c71400059.filter3c,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71400059.filter3c,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71400059.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end