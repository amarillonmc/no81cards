--模块更新
local m=20000312
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,m-2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2*ev
		local g2=Duel.GetMatchingGroup(function(c)return c:IsXyzSummonable(nil)end,tp,LOCATION_EXTRA,0,nil)
		local op=0
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,m-2) 
			and e:GetHandler():IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local cc=Duel.Release(e:GetHandler(),REASON_EFFECT)
			if cc==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,m-2)
			local tc=g:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
		if b1 and #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
		elseif #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
		else return end
		if op==0 then
			local g=Duel.GetDecktopGroup(1-tp,2*ev)
			local a=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g2:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end

	end)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_DECK)
		ge2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g=eg:Filter(function(c,tp)return c:IsControler(1-tp) end,nil,tp)
			e:SetLabel(g:GetCount())
			return g:GetCount()>0
		end)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
		end)
		Duel.RegisterEffect(ge2,0)
	end
end