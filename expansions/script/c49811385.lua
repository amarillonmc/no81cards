--イーグル・オブ・ガーディアン
local cm,m=GetID()

function cm.initial_effect(c)
    aux.AddCodeList(c,34022290)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(0x12)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e3)
    --
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_HAND_LIMIT)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(0x04)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.handlim)
	c:RegisterEffect(e9)
    local e8=e9:Clone()
    e8:SetTargetRange(0,1)
    e8:SetValue(cm.handlim2)
    c:RegisterEffect(e8)
end

function cm.spcfilter(c)
	return c:GetType()==0x40002 and not c:IsPublic()
end

function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_HAND,0,1,nil)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function cm.filter(c)
	return (aux.IsCodeListed(c,34022290) or c:IsCode(55569674)) and c:IsSSetable()
end

function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end

function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
        Duel.SSet(tp,g)
    end
end

function cm.limhandfilter(c)
    return c:IsPublic() and c:IsType(0x1) and c:IsSetCard(0x52)
end

function cm.handlim(e)
    return 6+Duel.GetMatchingGroupCount(cm.limhandfilter,e:GetHandlerPlayer(),0x02,0,nil)
end

function cm.handlim2(e)
    return 6-Duel.GetMatchingGroupCount(cm.limhandfilter,e:GetHandlerPlayer(),0x02,0,nil)
end