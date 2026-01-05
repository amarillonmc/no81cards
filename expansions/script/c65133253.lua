--幻叙天之月
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	--etxra link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.lmtg)
	e1:SetOperation(s.lmop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		function aux.GetLinkCount(c)
			if c:GetFlagEffect(id)>0 then
				return 1+0x10000*2
			elseif c:IsType(TYPE_LINK) and c:GetLink()>1 then
				return 1+0x10000*c:GetLink()
			else return 1 end
		end
	end
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x838)
end
function s.filter(c,lg)
	return c:IsFaceup() and lg:IsContains(c)
end
function s.lmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
end
function s.lmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end