--圆盘生物 汉古拉
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000123)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,dr",nil,nil,nil,cm.tg,cm.op,true)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>=2 end
	local dct=Duel.AnnounceNumber(tp,1,2)
	local dis=Duel.SelectDisableField(tp,dct,0,LOCATION_ONFIELD,0xe000e0)
	e:SetLabel(dis)
	e:SetValue(dct)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(cm.disop)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(rsreset.pend)
	Duel.RegisterEffect(e1,tp)
	local dct=e:GetValue()
	if rsufo.ToDeck(e,true) and Duel.IsPlayerCanDraw(1-tp,dct) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
		Duel.Draw(1-tp,dct,REASON_EFFECT)
	end
end
function cm.disop(e,tp)
	return e:GetLabel()
end