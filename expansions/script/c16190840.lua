--幼星体★未成之原色
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	--宣言    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsLinkSetCard(0xca0) and not c:IsLinkType(TYPE_LINK)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    getmetatable(e:GetHandler()).announce_filter={0xca0,OPCODE_ISSETCARD,TYPE_LINK,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()    
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetLabel(ac)
	e1:SetTarget(s.rmtg)
    e1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(e1,tp)
end
function s.rmtg(e,c)
	return c:IsCode(e:GetLabel())
end