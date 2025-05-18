--盛装的人偶
function c60158104.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c60158104.lmlimit)
	c:RegisterEffect(e1)
	
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158104,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60158104+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c60158104.e2con)
	e2:SetTarget(c60158104.e2tg)
	e2:SetOperation(c60158104.e2op)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158104,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60158104+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c60158104.e2con)
	e2:SetTarget(c60158104.e2tg)
	e2:SetOperation(c60158104.e22op)
	c:RegisterEffect(e2)
	
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158104,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,6018104)
	e3:SetTarget(c60158104.e3tg)
	e3:SetOperation(c60158104.e3op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	
	--change name
	aux.EnableChangeCode(c,60158101,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	
end

	--cannot link material

function c60158104.lmlimit(e,c)
	if not c then return false end
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and not c:IsCode(60158001)
end

	--spsummon proc
	
function c60158104.e2conf(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c60158104.e2con(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c60158104.e2conf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp)
end
function c60158104.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c60158104.e2conf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c60158104.e2op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c60158104.e22op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158104,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
end

	--tohand
	
function c60158104.e3tgf(c)
	return aux.IsCodeListed(c,60158001) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60158104.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158104.e3tgf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158104.e3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60158104.e3tgf),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end