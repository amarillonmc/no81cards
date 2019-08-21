--大魔王 谎言之王彼列
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121004
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.DMSpecialSummonEffect(c,m,true)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.xyztg)
	e2:SetCountLimit(1,m+100)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.filter2(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and tc:IsControler(tp) then
	   Duel.Overlay(tc,Group.FromCards(c))
	   local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,tc,tp)
	   if tc:GetOverlayGroup():IsContains(c) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and tc:IsControler(tp) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,rshint.xyz) 
		  local xyzg=g:Select(tp,1,1,nil)
		  Duel.HintSelection(xyzg)
		  local xyzc=xyzg:GetFirst()
		  if not xyzc:IsImmuneToEffect(e) then
			 local xyzmg=xyzc:GetOverlayGroup()
			 if xyzmg:GetCount()>0 then
				Duel.SendtoGrave(xyzmg,REASON_RULE)
			 end
			 Duel.Overlay(tc,xyzg) 
		  end  
	   end   
	end
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
