--白露未晞
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.rmcon)
	e2:SetOperation(s.xxop)
	c:RegisterEffect(e2)
    --SetEffect
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
    --battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function s.spfilter(c)
	return aux.IsCodeListed(c,13020010)
end
function s.spcon(e,c)
	if c==nil then return true end
    local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),0x02,0,1,nil)
        and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
    	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==re:GetHandler()
end
function s.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.spfilter,tp,0x02,0,nil)
    if c:IsOnField() and c:IsType(TYPE_XYZ) and #g>0 then
        Duel.Hint(3,tp,513)
        local sg=g:Select(tp,1,1,nil)
        Duel.Overlay(c,sg)
    end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Group.CreateGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_EQUIP)
	e1:SetLabel(0)
	e1:SetLabelObject(g)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.tyfi1ter(c)
    return (c:GetOriginalType()&TYPE_SPELL>0 and c:GetOriginalType()&TYPE_EQUIP>0)
        or (c:GetOriginalType()&TYPE_MONSTER>0 and c:GetOriginalType()&TYPE_UNION>0)
end
function s.thfi1ter(c,g)
    return s.tyfi1ter(c) and c:IsAbleToHand()
        and (g:GetCount()==0 or g:FilterCount(Card.IsCode,nil,c:GetOriginalCode())==0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
    local lg=e:GetLabelObject()
    local TohandCV=0
    local tc=eg:GetFirst()
    local g=Group.CreateGroup()
	while tc do
        if s.tyfi1ter(tc) and rp==tp then
            ct=ct+1
            if ct>=3 then
                ct=0
                TohandCV=TohandCV+1
            end
        end
        tc=eg:GetNext()
	end
	e:SetLabel(ct)
	while TohandCV>0 do
        local dg=Duel.GetMatchingGroup(s.thfi1ter,tp,0x01,0,nil,lg)
        if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            local stc=dg:RandomSelect(tp,1):GetFirst()
            if Duel.SendtoHand(stc,nil,0x40)>0 then
                g:AddCard(stc)
                Duel.ConfirmCards(1-tp,stc)
                local e2=Effect.CreateEffect(c)
			    e2:SetType(EFFECT_TYPE_FIELD)
			    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			    e2:SetTargetRange(1,0)
			    e2:SetValue(s.aclimit)
			    e2:SetLabel(stc:GetCode())
			    e2:SetReset(RESET_PHASE+PHASE_END)
			    Duel.RegisterEffect(e2,tp)
            end
        end
        TohandCV=TohandCV-1
	end
    if #g>0 then
        lg:Merge(g)
        lg:KeepAlive()
        e:SetLabelObject(lg)
    end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end