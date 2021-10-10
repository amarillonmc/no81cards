--罗德岛·特种干员-食铁兽
function c79029020.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c79029020.lvtg)
	e1:SetValue(c79029020.lvval)
	c:RegisterEffect(e1)
	--tgrc
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029020)
	e1:SetTarget(c79029020.tctg)
	e1:SetOperation(c79029020.tcop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029020.target)
	e2:SetOperation(c79029020.operation)
	c:RegisterEffect(e2)
end
function c79029020.lvtg(e,c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029020.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 5
	else return lv end
end
function c79029020.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029020.xyzop(e,tp,chk)
	if chk==0 then return true end
	Debug.Message("大展拳脚咯！")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029020,0))
end
function c79029020.tgfil(c)
	return c:IsSetCard(0xa904) and c:IsAbleToGrave()
end
function c79029020.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029020.tgfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetMaterialCount() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function c79029020.tcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=c:GetMaterialCount()
	local g=Duel.GetMatchingGroup(c79029020.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()<=0 or x<=0 then return end 
	Debug.Message("好！是时候大显身手了！")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029020,4))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	sg=g:Select(tp,1,x,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local count=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xa904)
	if count>0 and Duel.SelectYesNo(tp,aux.Stringid(79029020,3)) then 
	Debug.Message("这一战一定会很精彩！")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029020,5))
	Duel.Recover(tp,count*800,REASON_EFFECT)
	end
end
function c79029020.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c79029020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79029020.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c79029020.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79029020.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c79029020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	Debug.Message("曲中生直，柔能生刚！")  
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029020,1))
	end
end