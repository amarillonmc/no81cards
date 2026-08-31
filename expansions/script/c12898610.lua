--天锁斩月 黑崎一护
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcCodeFun(c,12898601,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--cannot fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.hspcon)
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	if not aux.check_bleach then
      aux.check_bleach=true
        local ge=Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        ge:SetCode(EVENT_ADJUST)
        ge:SetCondition(s.checkcon)
        ge:SetOperation(s.checkop)
        Duel.RegisterEffect(ge,0)
    end
end
function s.release_filter(c,tp,eg,ep,ev,re,r,rp,chk)
	return function(e)
		local cost=e:GetCost()
		if not cost then return false end
		local found=false
		bleach_Release=Card.IsReleasable
		function Card.IsReleasable(card,...)
				if card==c then
						found=true
				end
				return bleach_Release(card,...)
		end
		cost(e,c:GetControler(),nil,0,0,0,0,0,0)
		Card.IsReleasable=bleach_Release
		return found
	end
end
function s.checknull(c)
  local mt=_G["c"..c:GetOriginalCode()]
    return mt.bleach_mark==nil
end
function s.checkcon(e)
    return Duel.IsExistingMatchingCard(s.checknull,0,0xff,0xff,1,nil)
end
function s.checkop(e,...)
    local g=Duel.GetMatchingGroup(s.checknull,0,0xff,0xff,nil)
    for tc in aux.Next(g) do
      local mt=_G["c"..tc:GetOriginalCode()]
        if tc:IsOriginalEffectProperty(s.release_filter(tc,...)) then
            mt.bleach_mark=true
        else
            mt.bleach_mark=false
        end
    end
end
function s.hspfilter(c,tp,sc)
	return c:IsSetCard(0x3a7f) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
	and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),s.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.thfilter(c)
	local mt=_G["c"..c:GetOriginalCode()]
	return c:IsRace(RACE_WARRIOR+RACE_FIEND+RACE_ZOMBIE) and c:IsAbleToHand() and mt.bleach_mark==true
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		if (ct==0 or sg:IsContains(e:GetHandler())) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #ag>0 then
				Duel.SendtoHand(ag,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
			end
		end
	end
end